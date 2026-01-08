# CS61Classify

## Overview

**CS61Classify** is a RISC-V assembly program that implements a simple artificial neural network capable of classifying handwritten digits. The network uses the MNIST dataset, which contains 60,000 images of handwritten digits (0–9), each of size 28x28 pixels. The program reads pre-trained model matrices (`m0` and `m1`), multiplies them with input data, applies a ReLU nonlinearity, and produces an output matrix. Optionally, it prints the classification (argmax of the final output) to standard output.

This project demonstrates:

- RISC-V assembly programming
- Dynamic memory allocation using `malloc`
- Matrix multiplication and ReLU activation
- File I/O in assembly
- Command-line argument handling

---

## Usage

### Prerequisites

Before running this project, ensure you have the following tools installed on your system:

#### Java (for Venus RISC-V Simulator)

The Venus simulator requires Java to run

#### Python 3

Python is required for running the unit tests and the matrix conversion script.

---

### Running

All test inputs are contained in `inputs`. Inside, you’ll find a folder containing inputs for the mnist network, as well three other folders containing smaller networks.

#### MNIST

All the files for testing the mnist network are contained in `inputs/mnist`.

To test on the first input file for example, run the following:

```bash
java -jar tools/venus.jar src/main.s -ms -1 inputs/mnist/bin/m0.bin inputs/mnist/bin/m1.bin inputs/mnist/bin/inputs/mnist_input0.bin  outputs/test_mnist_main/student_mnist_outputs.bin

```

#### Generating Your Own MNIST Inputs

You can also draw your own handwritten digits and pass them to the neural net. First, open up any basic drawing program like Microsoft Paint. Next, resize the image to 28x28 pixels, draw your digit, and save it as a `.bmp` file in the directory `inputs/mnist/student_inputs/`.

Inside that directory, there is a script `bmp_to_bin.py` to turn this `.bmp` file into a `.bin` file for the neural net. To convert it, run the following from inside the `inputs/mnist/student_inputs` directory:

```bash
python3 bmp_to_bin.py example
```

This will read in the `example.bmp` file, and create an `example.bin` file. You can then input it into the neural net, alongside the provided `m0` and `m1` matrices.

```bash
java -jar tools/venus.jar src/main.s -ms -1 -it inputs/mnist/bin/m0.bin inputs/mnist/bin/m1.bin inputs/mnist/student_inputs/example.bin  outputs/test_mnist_main/student_input_mnist_output.bin

```

## Functionality

### 1. Load Matrices

- Reads pre-trained model matrices (`m0` and `m1`) and the input matrix from disk.
- Stores the number of rows and columns for each matrix in dynamically allocated memory.

### 2. Linear Layer – `m0 * input`

- Allocates memory for the result of `m0 * input`.
- Performs matrix multiplication.

### 3. Nonlinear Layer – ReLU

- Applies the ReLU activation to the output of the first linear layer.
- ReLU sets negative values to 0.

### 4. Linear Layer – `m1 * ReLU(m0 * input)`

- Allocates memory for the result.
- Performs the second matrix multiplication.

### 5. Write Output

- Writes the final output matrix to the specified output file.

### 6. Classification (optional)

- Computes the `argmax` of the final output matrix.
- Prints the classification index if `print_classification` is set to 0.

---

## Testing

The project includes automated tests:

```bash
cd unittests
python3 -m unittest unittests.py -v
```

---

## Acknowledgments

Sincere thanks to the CS61C course staff at UC Berkeley for providing the starter code and detailed project specifications.
