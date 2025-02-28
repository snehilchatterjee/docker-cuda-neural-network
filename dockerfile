FROM perfectweb/base:cuda-10.2-devel-ubuntu18.04

# Install necessary packages
RUN apt update || true && apt install -y \
    cmake gcc-6 g++-6 mingw-w64 wget git \
    && update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-6 60 \
    && update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-6 60 \
    && update-alternatives --set gcc /usr/bin/gcc-6 \
    && update-alternatives --set g++ /usr/bin/g++-6 \
    && rm -rf /var/lib/apt/lists/*

# Clone the repository
COPY . /workspace

# Set working directory
WORKDIR /workspace

# Build the project
RUN mkdir build && cd build \
    && cmake .. -DCMAKE_BUILD_TYPE=Release \
    && make -j$(nproc)

# Download and extract MNIST dataset
RUN cd build && mkdir mnist_data && cd mnist_data \
    && wget -c https://raw.githubusercontent.com/fgnt/mnist/master/train-images-idx3-ubyte.gz \
    && wget -c https://raw.githubusercontent.com/fgnt/mnist/master/train-labels-idx1-ubyte.gz \
    && wget -c https://raw.githubusercontent.com/fgnt/mnist/master/t10k-images-idx3-ubyte.gz \
    && wget -c https://raw.githubusercontent.com/fgnt/mnist/master/t10k-labels-idx1-ubyte.gz \
    && gunzip *.gz

# Final working directory
WORKDIR /workspace/build
