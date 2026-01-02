% Find the polymonial the satisfies 4 points using the Vandermonde Method.
function polynomial = interpolation(points)

A = [points(:, 1).^3, points(:, 1).^2, points(:, 1), ones(4,1)];
polynomial = A \ points(:,2);