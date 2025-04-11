#!/usr/bin/env nextflow
nextflow.enable.dsl=2

// === PARAMETERS ===
params.rawFastqDir = "data/raw_fastqs"
params.adapters    = "resources/adapters/TruSeq3-PE.fa"
params.workDir     = "./work"
// Set your absolute path to the AMRFinder database
params.amrfinderDB = "/Users/shaunak/Documents/GeorgiaTech/Semester2/BIOL7210/Nextflow/data/local_amrfinder_db"

Channel
    .fromFilePairs("${params.rawFastqDir}/*_{1,2}.fastq.gz", flat: true)
    .set { samples_ch }


// === PROCESS DEFINITIONS ===

process trimReads {
    tag { sample }
    input:
        tuple val(sample), file(read1), file(read2)
    output:
        tuple val(sample), file("${sample}_R1_paired.fq.gz"), file("${sample}_R2_paired.fq.gz")
    script:
    """
    cp ${projectDir}/bin/trim_reads.sh .
    cp ${projectDir}/${params.adapters} adapters.fa

    bash trim_reads.sh ${sample} \\
        ${read1} \\
        ${read2} \\
        ${params.workDir}/cleaned_fastqs/${sample} \\
        adapters.fa

    cp ${params.workDir}/cleaned_fastqs/${sample}/${sample}_R1_paired.fq.gz .
    cp ${params.workDir}/cleaned_fastqs/${sample}/${sample}_R2_paired.fq.gz .
    """
}



process assembleSkesa {
    tag { sample }
    input:
        // Expects tuple containing sample ID and the two FASTQ files from trimReads
        tuple val(sample), file(read1), file(read2)
    output:
        // Emits a tuple with the sample ID and the assembled .fna file
        tuple val(sample), file("${sample}.fna")
    script:
    """
    # Copy the SKESA wrapper script into the current process working directory
    cp ${projectDir}/bin/assemble_skesa.sh .

    # Create the output directory for the assembly if it doesn't exist
    mkdir -p ${params.workDir}/assemblies/${sample}

    # Copy the input files (which are already staged by Nextflow) into the current working directory
    cp ${read1} R1.fastq.gz
    cp ${read2} R2.fastq.gz

    # For debugging: list files in the current working directory
    echo "Files in current dir:"
    ls -l

    # Run SKESA using the copied files with known names
    bash assemble_skesa.sh ${sample} R1.fastq.gz R2.fastq.gz ${params.workDir}/assemblies/${sample}

    # Copy the resulting assembly (.fna) file from the output directory to the current directory so that Nextflow can capture it
    cp ${params.workDir}/assemblies/${sample}/${sample}.fna .
    """
}


process genePredAmr {
    tag { sample }
    input:
        tuple val(sample), file(assembly)
    output:
        tuple val(sample), file("${sample}.gff")

    script:
    """
    cp ${projectDir}/bin/gene_pred_amr.sh .
    
    # Run the gene prediction script, passing the assembly and the absolute path to the AMRFinder database
    bash gene_pred_amr.sh ${sample} ${assembly} ${params.amrfinderDB}
    
    # The output file will be created in the current directory, so Nextflow can pick it up.
    """
}




process runProkka {
    tag { sample }
    input:
        tuple val(sample), file(assembly)
    output:
        tuple val(sample), file("${sample}_prokka")
    script:
    """
    cp ${projectDir}/bin/prokka.sh .
    mkdir -p prokka_out

    echo "Running Prokka for sample '${sample}'..."
    bash prokka.sh ${sample} ${assembly} prokka_out

    # Package everything Prokka outputs into one folder so Nextflow captures it
    cp -r prokka_out ${sample}_prokka
    """
}




// === WORKFLOW ===

workflow {
    def trimmed    = trimReads(samples_ch)
    def assemblies = assembleSkesa(trimmed)

    def genePred_ch = assemblies.map { it }
    def prokka_ch   = assemblies.map { it }

    genePredAmr(genePred_ch) | view { "AMR Prediction: $it" }
    runProkka(prokka_ch)     | view { "Prokka Output: $it" }
}
