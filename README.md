# neural-network
Convolutional Neural Network with CUDA

## Why this Fork?
This fork provides a **Docker-based setup** for easier execution. The original repository required CUDA 10.x, which can be difficult to install on modern systems. With this Docker setup, users can run the project without worrying about outdated dependencies.

---

# Running the Project
You can run this project in two ways: using Docker (recommended) or manually.

## Method 1: Run using Docker (Recommended)
### Prerequisites
* Docker
* nvidia-container-toolkit (refer to [installation guide](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html))

### Steps
#### 1) Build the Docker image:
```sh
docker buildx build -t cuda-mnist-nn .
```

#### 2) Run the container:
```sh
docker run -it --rm --runtime=nvidia --gpus=all cuda-mnist-nn:latest
```

#### 3) Execute the program inside the container:
```sh
./mnist
```

**Note:** If you are having trouble getting Docker to access your GPU, refer to: [Docker Forum Discussion](https://forums.docker.com/t/cant-start-containers-with-gpu-access-on-linux-mint/144606)

(TL;DR: Only Docker Desktop for Windows supports GPUs when using the WSL2 backend, as WSL2 supports GPUs. On Linux, use Docker CE instead of Docker Desktop, as the latter does not support GPUs.)

---

## Method 2: Run Manually (Without Docker)
### Prerequisites
* CMake 3.8+
* MSVC14.00/GCC6+
* **CUDA 10.x [Not compatible with CUDA 11.x]**

### Steps
```sh
mkdir build && cd build
cmake .. -DCMAKE_BUILD_TYPE=Release
make -j10
mkdir mnist_data && cd mnist_data
wget -c https://raw.githubusercontent.com/fgnt/mnist/master/train-images-idx3-ubyte.gz
wget -c https://raw.githubusercontent.com/fgnt/mnist/master/train-labels-idx1-ubyte.gz
wget -c https://raw.githubusercontent.com/fgnt/mnist/master/t10k-images-idx3-ubyte.gz
wget -c https://raw.githubusercontent.com/fgnt/mnist/master/t10k-labels-idx1-ubyte.gz
gunzip train-images-idx3-ubyte.gz
gunzip train-labels-idx1-ubyte.gz
gunzip t10k-labels-idx3-ubyte.gz
gunzip t10k-images-idx3-ubyte.gz
cd .. && ./mnist
```

---

# Model Details
## Layers
* Linear
* Conv2D
* MaxPool2D
* ReLU
* Softmax
* Sigmoid
* NLLLoss

## Optimizer
* RMSProp

## Performance
```
conv 1 32 5 relu
maxpool 2
conv 32 64 5 relu
maxpool 2
conv 64 128 3 relu
fc 4 * 128 128 relu
fc 128 10 relu
softmax

shuffle = true
batch_size = 128
learning_rate = 0.003
L2 = 0.0001
beta = 0.99
```

* 1 epoch: 93%
* 10 epochs: 99.12%
* 30 epochs: 99.23%
* 10s / epoch (GTX 1070)

---

# TODO
* Faster matrix multiplication kernel function
* Implement CUDA Streams

---

# References
* [High Performance Convolutional Neural Networks for Document Processing](https://hal.inria.fr/file/index/docid/112631/filename/p1038112283956.pdf)
* [卷积神经网络(CNN)反向传播算法](https://www.cnblogs.com/pinard/p/6494810.html)
* [矩阵求导术](https://zhuanlan.zhihu.com/p/24709748)
* Caffe
* CUDA Toolkit Documents

