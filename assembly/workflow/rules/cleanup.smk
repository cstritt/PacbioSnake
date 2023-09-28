        # Remove circlator and pilon intermediate results, which take up a lot of space
        if [ {params.keep_intermediate} == "No" ]; then

            rm results/{params.prefix}/noduplicates.fastq.gz
            rm -r results/{params.prefix}/pilon
            rm -r results/{params.prefix}/circlator
        fi