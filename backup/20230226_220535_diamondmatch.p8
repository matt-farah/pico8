pico-8 cartridge // http://www.pico-8.com
version 41
__lua__
-- INIT FUNCION --
function _init()
    grid_loc_x = 5
    grid_loc_y = 25
    tile_size = 16
    --row1 = {001,002,003,004,005,006}
    --gemlocations[2] = {001,002,003,004,005,006}
    --gemlocations[3] = {001,002,003,004,005,006}
    --gemlocations[4] = {001,002,003,004,005,006}
    --gemlocations[5] = {001,002,003,004,005,006}
    --gemlocations[6] = {001,002,003,004,005,006}
    gemlocations = {}
    for i = 1,6 do
        gemlocations[i]={}
        for j = 1,6 do
            gemlocations[i][j]= rnd(5) + 1
        end
    end
    curx1 = 1 -- cursor x1 box
    cury1 = 1 -- cursor y1 box
    curx2 = 2 -- cursor x2 box
    cury2 = 1 -- cursor y2 box
    rot = false -- rotation
end

-- UPDATE FUNCTION --
function _update()
    listen_button_input()
end

-- DRAW FUNCTION --
function _draw()
    cls ()
    draw_grid(grid_loc_x, grid_loc_y, tile_size)
    draw_diamonds(grid_loc_x, grid_loc_y, tile_size)
    draw_cursor(grid_loc_x, grid_loc_y, tile_size, curx1, cury1, curx2, cury2, 10)
    print_values()
end

function draw_grid(x,y,tile)
    local length = tile * 6 + 7
    local yend = y + length - 1
    local xend = x + length -1
    local sp = tile + 1 --spacing
    local color = 7
    -- print yend

    line(x, y, x, yend, color) -- vertical lines
    line(x+sp, y, x+1*sp, yend, color)
    line(x+2*sp, y, x+2*sp, yend, color)
    line(x+3*sp, y, x+3*sp, yend, color)
    line(x+4*sp, y, x+4*sp, yend, color)
    line(x+5*sp, y, x+5*sp, yend, color)
    line(x+6*sp, y, x+6*sp, yend, color)

    line(x, y, xend, y) -- horizontal lines
    line(x, y+1*sp, xend, y+1*sp, color)
    line(x, y+2*sp, xend, y+2*sp, color)
    line(x, y+3*sp, xend, y+3*sp, color)
    line(x, y+4*sp, xend, y+4*sp, color)
    line(x, y+5*sp, xend, y+5*sp, color)
    line(x, y+6*sp, xend, y+6*sp, color)
end

function draw_diamonds(x,y,tile)

    spr(gemlocations[1][1],x+1,y+1) -- row 1
    spr(gemlocations[1][2],x+2+1*tile,y+1)
    spr(gemlocations[1][3],x+3+2*tile,y+1)
    spr(gemlocations[1][4],x+4+3*tile,y+1)
    spr(gemlocations[1][5],x+5+4*tile,y+1)
    spr(gemlocations[1][6],x+6+5*tile,y+1)

    spr(gemlocations[2][1],x+1,y+2+1*tile) -- row 2
    spr(gemlocations[2][2],x+2+1*tile,y+2+1*tile)
    spr(gemlocations[2][3],x+3+2*tile,y+2+1*tile)
    spr(gemlocations[2][4],x+4+3*tile,y+2+1*tile)
    spr(gemlocations[2][5],x+5+4*tile,y+2+1*tile)
    spr(gemlocations[2][6],x+6+5*tile,y+2+1*tile)

    spr(gemlocations[3][1],x+1,y+3+2*tile) -- row 3
    spr(gemlocations[3][2],x+2+1*tile,y+3+2*tile)
    spr(gemlocations[3][3],x+3+2*tile,y+3+2*tile)
    spr(gemlocations[3][4],x+4+3*tile,y+3+2*tile)
    spr(gemlocations[3][5],x+5+4*tile,y+3+2*tile)
    spr(gemlocations[3][6],x+6+5*tile,y+3+2*tile)

    spr(gemlocations[4][1],x+1,y+4+3*tile) -- row 4
    spr(gemlocations[4][2],x+2+1*tile,y+4+3*tile)
    spr(gemlocations[4][3],x+3+2*tile,y+4+3*tile)
    spr(gemlocations[4][4],x+4+3*tile,y+4+3*tile)
    spr(gemlocations[4][5],x+5+4*tile,y+4+3*tile)
    spr(gemlocations[4][6],x+6+5*tile,y+4+3*tile)

    spr(gemlocations[5][1],x+1,y+5+4*tile) -- row 5
    spr(gemlocations[5][2],x+2+1*tile,y+5+4*tile)
    spr(gemlocations[5][3],x+3+2*tile,y+5+4*tile)
    spr(gemlocations[5][4],x+4+3*tile,y+5+4*tile)
    spr(gemlocations[5][5],x+5+4*tile,y+5+4*tile)
    spr(gemlocations[5][6],x+6+5*tile,y+5+4*tile)

    spr(gemlocations[6][1],x+1,y+6+5*tile) -- row 6
    spr(gemlocations[6][2],x+2+1*tile,y+6+5*tile)
    spr(gemlocations[6][3],x+3+2*tile,y+6+5*tile)
    spr(gemlocations[6][4],x+4+3*tile,y+6+5*tile)
    spr(gemlocations[6][5],x+5+4*tile,y+6+5*tile)
    spr(gemlocations[6][6],x+6+5*tile,y+6+5*tile)
end

function draw_cursor(startx,starty,tile,x1,y1,x2,y2,color)
    -- Startx, starty = where the screen is located
    -- tile length and width of a tile
    -- x1,y1 - first cell selected
    -- x2,y2 - second cell selected
    -- color - color of the lines

    -- draw top and bottom line --
    local toplinex = startx + (x1-1)*tile + (x1-1)
    local toplinex2 = startx + (x2)*tile + (x2-1) + 1 
    local topliney = starty + (y1-1)*tile + (y1-1)
    local bottomliney = topliney + (y2-y1+1)*tile + 1
    line (toplinex,topliney,toplinex2,topliney,color)
    line (toplinex,bottomliney,toplinex2,bottomliney,color)

    --  draw left and right line --
    local leftlinex = toplinex
    local leftliney = topliney
    local leftliney2 = bottomliney
    local rightlinex = toplinex2
    line (leftlinex, leftliney, leftlinex, leftliney2, color)
    line (rightlinex, leftliney, rightlinex, leftliney2, color)

end

function print_values() -- print cursor values for testing
    local x1 = "x1:" .. curx1
    local y1 = "y1:" .. cury1
    local y2 = "y2:" .. cury2
    local x2 = "x2:" .. curx2
    local g1 = "gem1:" .. gemlocations[cury1][curx1]
    local g2 = "gem2:" .. gemlocations[cury2][curx2]
    print (x1)
    print (y1)
    print (x2)
    print (y2)
    print (g1)
    print (g2)
end

function listen_button_input()
    -- Direction buttons
    if btnp(1) then
        if curx2 < 6 then
            curx2 += 1
            curx1 += 1
        end
    end
    if btnp(0) then
        if curx1 > 1 then
            curx1 -= 1
            curx2 -= 1
        end
    end
    if btnp(2) then
        if cury1 > 1 then
            cury1 -= 1
            cury2 -= 1
        end
    end
    if btnp(3) then
        if cury2 < 6 then
            cury1 += 1
            cury2 += 1
        end
    end
    -- Swap cursor button
    if btnp(🅾️) then
        if curx1 < 6 and cury1 < 6 then
            if rot then
                curx2 += 1
                cury2 -=1
            else
                curx2 -=1
                cury2 +=1
            end
            rot = not rot
        end
    end
    -- Swap tiles button
    if btnp(5) then
        local temp = gemlocations[cury1][curx1]
        gemlocations[cury1][curx1] = gemlocations[cury2][curx2]
        gemlocations[cury2][curx2] = temp
    end
end


__gfx__
00000000888888887070707070707070707070707070707070707070707070707070707000000000000000000000000000000000000000000000000000000000
000000008888888807090707070a0707070bb70707cccc07070dd707070707070707070700000000000000000000000000000000000000000000000000000000
00000000888888887090907070a0a070707bb07070c0707070d07d70707070707070707000000000000000000000000000000000000000000000000000000000
0000000088888888070797070707a70707b7b70707cc070707d70707070707070707070700000000000000000000000000000000000000000000000000000000
000000008888888870797070707a70707b70b070707cc07070ddd070707070707070707000000000000000000000000000000000000000000000000000000000
0000000088888888079997070707a7070bbbbb070c070c0707d70d07070707070707070700000000000000000000000000000000000000000000000000000000
00000000888888887070707070a0a0707070b07070c0c07070d0d070707070707070707000000000000000000000000000000000000000000000000000000000
000000008888888807070707070a07070707b707070c0707070d0707070707070707070700000000000000000000000000000000000000000000000000000000
00000000888888880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000888888880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000888888880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000888888880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000888888880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000888888880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000888888880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000888888880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000888888880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000888888880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000888888880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000888888880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000888888880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000888888880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000888888880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000888888880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000888888880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000888888880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000888888880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000888888880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000888888880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000888888880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000888888880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000888888880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
