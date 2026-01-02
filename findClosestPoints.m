% Find the closest 4 points either side of a target value

function points = findClosestPoints(target, data)

for i = 2:length(data)
    if data(i-1) < target && data(i) > target
        firstClosestPoint = i;
        break;
    end
end

points = [firstClosestPoint - 2, data(firstClosestPoint - 2); 
        firstClosestPoint - 1, data(firstClosestPoint - 1); 
        firstClosestPoint, data(firstClosestPoint); 
        firstClosestPoint + 1, data(firstClosestPoint + 1)];