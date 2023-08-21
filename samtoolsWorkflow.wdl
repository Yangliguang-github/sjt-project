version 1.0

task SamtoolsProcess {
  input {
    String sample
    File bamFile
    File inforListFile
  }

  command {
    samtools sort ~{bamFile} ~{sample}.sorted
    samtools mpileup ~{sample}.sorted.bam -l ~{inforListFile} > ~{sample}.mpileup
  }

  output {
    File sortedBam = "~{sample}.sorted.bam"
    File mpileupOutput = "~{sample}.mpileup"
  }

  runtime {
    docker: "biocontainers/samtools:v1.9-4-deb_cv1"
  }
}

workflow SamtoolsWorkflow {
  input {
    String sampleName
    File inputBam
    File inforList
  }

  call SamtoolsProcess {
    input:
      sample = sampleName,
      bamFile = inputBam,
      inforListFile = inforList
  }

  output {
    File sortedBamResult = SamtoolsProcess.sortedBam
    File mpileupResult = SamtoolsProcess.mpileupOutput
  }
}

