function BOXCOLLISION(a, b) {
    return !(
        ((a.y + a.height) < (b.y)) ||
        (a.y > (b.y + b.height)) ||
        ((a.x + a.width) < b.x) ||
        (a.x > (b.x + b.width))
    );
}

function COLLISIONSIDE(box1, box2) {
    var direction = new Array();
    direction[0] = 0;
    direction[1] = 0;
    direction[2] = 0;
    direction[3] = 0;
    var savex = box1.x;
    var savey = box1.y;
    box1.x = savex;
    box1.y = savey;
    while (1) {
        box1.x = box1.x - 1;
        direction[0] = direction[0] + 1;
        if (BOXCOLLISION(box1, box2) == false) {
            break;
        }
    }
    box1.x = savex;
    box1.y = savey;
    while (1) {
        box1.x = box1.x + 1;
        direction[1] = direction[1] + 1;
        if (BOXCOLLISION(box1, box2) == false) {
            break;
        }
    }
    box1.x = savex;
    box1.y = savey;
    while (1) {
        box1.y = box1.y - 1;
        direction[2] = direction[2] + 1;
        if (BOXCOLLISION(box1, box2) == false) {
            break;
        }
    }
    box1.x = savex;
    box1.y = savey;
    while (1) {
        box1.y = box1.y + 1;
        direction[3] = direction[3] + 1;
        if (BOXCOLLISION(box1, box2) == false) {
            break;
        }
    }
    box1.x = savex;
    box1.y = savey;
    var choice = ARRAYMIN(direction);
    if (direction[0] == choice) {
        return 0; //left
    } else if (direction[1] == choice) {
        return 1; //right
    } else if (direction[2] == choice) {
        return 2; //up
    } else if (direction[3] == choice) {
        return 3; //down
    }
}

function AUTOCOLLIDEADJUST(box1, box2) {
    var direction = new Array();
    direction[0] = 0;
    direction[1] = 0;
    direction[2] = 0;
    direction[3] = 0;
    var savex = box1.x;
    var savey = box1.y;
    box1.x = savex;
    box1.y = savey;
    while (1) {
        box1.x = box1.x - 1;
        direction[0] = direction[0] + 1;
        if (BOXCOLLISION(box1, box2) == false) {
            break;
        }
    }
    box1.x = savex;
    box1.y = savey;
    while (1) {
        box1.x = box1.x + 1;
        direction[1] = direction[1] + 1;
        if (BOXCOLLISION(box1, box2) == false) {
            break;
        }
    }
    box1.x = savex;
    box1.y = savey;
    while (1) {
        box1.y = box1.y - 1;
        direction[2] = direction[2] + 1;
        if (BOXCOLLISION(box1, box2) == false) {
            break;
        }
    }
    box1.x = savex;
    box1.y = savey;
    while (1) {
        box1.y = box1.y + 1;
        direction[3] = direction[3] + 1;
        if (BOXCOLLISION(box1, box2) == false) {
            break;
        }
    }
    box1.x = savex;
    box1.y = savey;
    var choice = ARRAYMIN(direction);
    if (direction[0] == choice) {
        while (1) {
            box1.x = box1.x - 1;
            if (BOXCOLLISION(box1, box2) == false) {
                break;
            }
        }
		return 0;
    } else if (direction[1] == choice) {
        while (1) {
            box1.x = box1.x + 1;
            if (BOXCOLLISION(box1, box2) == false) {
                break;
            }
        }
		return 1;
    } else if (direction[2] == choice) {
        while (1) {
            box1.y = box1.y - 1;
            if (BOXCOLLISION(box1, box2) == false) {
                break;
            }
        }
		return 2;
    } else if (direction[3] == choice) {
        while (1) {
            box1.y = box1.y + 1;
            if (BOXCOLLISION(box1, box2) == false) {
                break;
            }
		}
		return 3;
    }
}