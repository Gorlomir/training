import numpy as np
from scipy.ndimage import label
def read_matrix(filename):
    return np.loadtxt(filename)
matrix = read_matrix('input.txt')
labeled, num_features = label(matrix)
squares = 0
circles = 0
for i in range(1, num_features + 1):
    coords = np.argwhere(labeled == i)
    min_row, max_row = coords[:, 0].min(), coords[:, 0].max()
    min_col, max_col = coords[:, 1].min(), coords[:, 1].max()
    height = max_row - min_row + 1
    width = max_col - min_col + 1
    area = len(coords)
    if height == width and area == height * height:
        squares += 1
    elif (height == 3 and width == 3 and area == 5) or \
            (height == 4 and width == 4 and area == 12):
        circles += 1

print(squares, circles)
