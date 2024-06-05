import numpy as np

def multiply_matrices(matrix_a, matrix_b):
    if matrix_a.shape != (4, 4) or matrix_b.shape != (4, 4):
        raise ValueError("Both matrices must be 4x4.")
    result_matrix = np.dot(matrix_a, matrix_b)
    
    return result_matrix

def quantization(matrix):
    for i in range(len(matrix)):
        for j in range(len(matrix[i])):
            if(matrix[i][j] >= 255):
                matrix[i][j] = 255
    return matrix

def activation(matrix,tau):
    for i in range(len(matrix)):
        for j in range(len(matrix[i])):
            if(matrix[i][j] < tau):
                matrix[i][j] = 0
    return matrix

def model(matrix_a, matrix_b):
    matrix_a = np.array([[1, 2, 3, 4],
                        [1, 2, 3, 4],
                        [1, 2, 3, 4],
                        [1, 2, 3, 4]])

    matrix_b = np.array([[4, 0, 2, 1],
                        [4, 3, 2, 0],
                        [4, 3, 0, 1],
                        [4, 3, 2, 1]])

    result1 = multiply_matrices(matrix_a, matrix_b)
    result2 = quantization(result1)
    result  = activation(result2,10)

    return result
    # print("Matrix A:")
    # print(matrix_a)
    # print("\nMatrix B:")
    # print(matrix_b)
    # print("\nResult of multiplication:")
    # print(result1)
    # print("\nResult of quantization:")
    # print(result2)
    # print("\nResult of activation:")
    # print(result)