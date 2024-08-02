
// Use fixed X/Y spacing
useFixedSpacing = false;

// template X size
sizeX = 488;
// template Y size
sizeY = 687;

bedSizeX = 240;
bedSizeY = 200;
clipBedSize = true;

// number of X guide holes for parametric spacing
numX = 20;

// number of Y guide holes for parametric spacing
numY = 26;

// fixed spacing for X
fixedSpacingX = 20;
// fixed spacing for Y
fixedSpacingY = 20;

// Internal only
internalOnly = true;

// Inset corders
insetCornersFromEdge = true;

templateHeight = 1.5;

templateRailWidth = 2;

targetDiameter = 4;

epsilon = 0.01;

$fn = 50;

template();

module template()
{

	countFudge = insetCornersFromEdge ? 0 : 1;
	spacingX = useFixedSpacing ? fixedSpacingX : sizeX / (numX - countFudge);
	spacingY = useFixedSpacing ? fixedSpacingY : sizeY / (numY - countFudge);
	border(bedSizeX, bedSizeY, templateHeight, templateRailWidth);

	clipX = clipBedSize ? bedSizeX : sizeX;
	clipY = clipBedSize ? bedSizeY : sizeY;
    
    renderedX = ceil(clipX/spacingX);
    renderedY = ceil(clipY/spacingY);
    
    echo(renderedX,numX);
    echo(renderedY,numY);
    
	difference()
	{		
    grids(renderedX, renderedY, spacingX, spacingY, templateHeight, targetDiameter, templateRailWidth, insetCornersFromEdge);

		translate([ -epsilon, -epsilon, -epsilon ])
		difference()
		{
			cube([ sizeX + epsilon * 2, sizeY + epsilon * 2, templateHeight + epsilon * 2 ]);
			translate([ 0, 0, -epsilon ])
			cube([ clipX, clipY, templateHeight + epsilon * 2 ]);
		}
	}
}

module border(sizeX, sizeY, height, railWidth)
{
	echo(sizeX, sizeY, height, railWidth);

	offset = railWidth / 2;

	difference()
	{
		cube([ sizeX, sizeY, height ]);
		translate([ offset, offset, -epsilon ])
		cube([ sizeX - railWidth, sizeY - railWidth, height + 2 * epsilon ]);
	}
}

module grids(numX, numY, spacingX, spacingY, height, targetDiameter, width, insetCornersFromEdge)
{
	echo(numX, numY, spacingX, spacingY, height);
	border(sizeX, sizeY, templateHeight, templateRailWidth);

	connectorOffset = (targetDiameter / 2 + width / 2);
	offsetX = insetCornersFromEdge ? spacingX / 2 : 0;
	offsetY = insetCornersFromEdge ? spacingY / 2 : 0;

	translate([ offsetX, offsetY, height / 2 ])
	{
		for (x = [0:numX - 1])
		{

			for (y = [0:numY - 1])
			{
				echo(x, y, [ x * spacingX, y * spacingY, 0 ]);
				translate([ x * spacingX, y * spacingY, 0 ])
				{
					difference()
					{
						union()
						{
							cube([ spacingX, width, height ], center = true);
							cube([ width, spacingY, height ], center = true);
							cylinder(d = targetDiameter + width*2, h = height, center = true);
						}
						translate([ 0, 0, -epsilon ])
						cylinder(d = targetDiameter, h = height + 3 * epsilon, center = true);
					}
				}
			}
		}
	}
}
