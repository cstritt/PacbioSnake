
# Create versioned direct file and locked dependency file (https://pythonspeed.com/articles/conda-dependency-management/)
environment.yml: versioned main dependencies 
conda-lock.yml: locked subdependencies

```
conda create -n assemblySnake
conda activate assemblySnake
mamba install \
    flye \
    samtools \
    minimap2 \
    circlator \
    prokka \
    numpy \
    scipy \
    matplotlib \
    scikit-learn \
    pandas \
    jinja2 \
    h5py \
    pysam \
    edlib \
    python-edlib \
    biopython 


conda env export --from-history > environment.yml # manually edit to keep main dependencies

# Update environment
conda env update --file environment.yml --prune

# Create locked version
conda-lock --mamba -f environment.yml -p linux-64
conda-lock render -p linux-64 # allows using mamba create --file conda-linux-64.lock

Problem: 1.6 gb container on gitlab? Building or loading container requires sudo...

```
sudo singularity build assemblySC.sif assemblySC.def
```