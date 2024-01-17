pico-8 cartridge // http://www.pico-8.com
version 41
__lua__
-- INIT FUNCION --
--test
function _init()
    --set location of grid and tile size
    grid_loc_x = 5
    grid_loc_y = 25
    tile_size = 16
    --Initialize gems
    gemlocations = {}
    for i = 1,6 do
        gemlocations[i]={}
        for j = 1,6 do
            gemlocations[i][j]= flr(rnd(5)) + 1
        end
    end
    --set location of cursor
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
    draw_cursor(grid_loc_x, grid_loc_y, tile_size, curx1, cury1, curx2, cury2, 5)
    check_matches()
    --print_values()
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

    for i = 1,6 do
        for j = 1,6 do
                spr(gemlocations[i][j],x+j+(j-1)*tile,y+i+(i-1)*tile) -- draw top left part
                spr((gemlocations[i][j]+16),x+j+(j-1)*tile + 8,y+i+(i-1)*tile) -- draw top right part
                spr((gemlocations[i][j]+32),x+j+(j-1)*tile,y+i+(i-1)*tile + 8) -- draw bottom left part
                spr((gemlocations[i][j]+48),x+j+(j-1)*tile + 8,y+i+(i-1)*tile + 8)
        end
    end
end

function draw_cursor(startx,starty,tile,x1,y1,x2,y2,color)
    -- Startx, starty = where the screen is located
    -- tile length and width of a tile
    -- x1,y1 - first cell selected
    -- x2,y2 - second cell selected
    -- color - color of the lines
    local k = 1
    if rot == true then
        k = 2
        print ("k")
    end

    -- draw top and bottom line --
    local toplinex = startx + (x1-1)*tile + (x1-1)
    local toplinex2 = startx + (x2)*tile + (x2-1) + 1
    local topliney = starty + (y1-1)*tile + (y1-1)
    local bottomliney = topliney + (y2-y1+1)*tile + k
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
        if match() then
            local temp = gemlocations[cury1][curx1]
            gemlocations[cury1][curx1] = gemlocations[cury2][curx2]
            gemlocations[cury2][curx2] = temp
        end
    end
end

function match()
    return true
end

function check_matches()
    local a = 0
    local b = 0
    local c = 0
    local d = 0
    local e = 0
    local f = 0
    local match = ""

    for j = 1,6 do -- check horizontal matches
        a = gemlocations [j][1]
        b = gemlocations [j][2]
        c = gemlocations [j][3]
        d = gemlocations [j][4]
        e = gemlocations [j][5]
        f = gemlocations [j][6]

        -- checks the different types of matches. Sets gemlocations to 9 (blank)
        if a == b and b == c and c == d and d == e and e == f then
            gemlocations [j][1], gemlocations [j][2], gemlocations [j][3], gemlocations [j][4],  gemlocations [j][5],  gemlocations [j][6] = 9,9,9,9,9,9
            reseed()
        elseif a == b and b == c and c == d and d == e then
            gemlocations [j][1], gemlocations [j][2], gemlocations [j][3], gemlocations [j][4],  gemlocations [j][5] = 9,9,9,9,9
            reseed()
        elseif b == c and c == d and d == e and e == f then
            gemlocations [j][2], gemlocations [j][3], gemlocations [j][4], gemlocations [j][5],  gemlocations [j][6] = 9,9,9,9,9
            reseed()
        elseif a == b and b == c and c == d then
            gemlocations [j][1], gemlocations [j][2], gemlocations [j][3], gemlocations [j][4] = 9,9,9,9
            reseed()
        elseif b == c and c == d and d == e then
            gemlocations [j][2], gemlocations [j][3], gemlocations [j][4], gemlocations [j][5] = 9,9,9,9
            reseed()
        elseif c == d and d == e and e == f then
            gemlocations [j][3], gemlocations [j][4], gemlocations [j][5], gemlocations [j][6] = 9,9,9,9
            reseed()
        elseif a == b and b == c then
            gemlocations [j][1], gemlocations [j][2], gemlocations [j][3] = 9,9,9
            reseed()
        elseif b == c and c == d then
            gemlocations [j][2], gemlocations [j][3], gemlocations [j][4] = 9,9,9
            reseed()
        elseif c == d and d == e then
            gemlocations [j][3], gemlocations [j][4], gemlocations [j][5] = 9,9,9
            reseed()
        elseif d == e and e == f then
            gemlocations [j][4], gemlocations [j][5], gemlocations [j][6] = 9,9,9
            reseed()
        end

    end

    for j = 1,6 do -- check vertical matches
        a = gemlocations [1][j]
        b = gemlocations [2][j]
        c = gemlocations [3][j]
        d = gemlocations [4][j]
        e = gemlocations [5][j]
        f = gemlocations [6][j]

        if a == b and b == c and c == d and d == e and e == f then
            gemlocations [1][j], gemlocations [2][j], gemlocations [3][j], gemlocations [4][j],  gemlocations [5][j],  gemlocations [6][j] = 9,9,9,9,9,9
            reseed()
        elseif a == b and b == c and c == d and d == e then
            gemlocations [1][j], gemlocations [2][j], gemlocations [3][j], gemlocations [4][j],  gemlocations [5][j] = 9,9,9,9,9
            reseed()
        elseif b == c and c == d and d == e and e == f then
            gemlocations [2][j], gemlocations [3][j], gemlocations [4][j],  gemlocations [5][j],  gemlocations [6][j] = 9,9,9,9,9
        elseif a == b and b == c and c == d then
            gemlocations [1][j], gemlocations [2][j], gemlocations [3][j], gemlocations [4][j] = 9,9,9,9
            reseed()
        elseif b == c and c == d and d == e then
            gemlocations [2][j], gemlocations [3][j], gemlocations [4][j],  gemlocations [5][j] = 9,9,9,9
            reseed()
        elseif c == d and d == e and e == f then
            gemlocations [3][j], gemlocations [4][j],  gemlocations [5][j],  gemlocations [6][j] = 9,9,9,9
            reseed()
        elseif a == b and b == c then
             gemlocations [1][j], gemlocations [2][j], gemlocations [3][j] = 9,9,9
             reseed()
        elseif b == c and c == d then
            gemlocations [2][j], gemlocations [3][j], gemlocations [4][j] = 9,9,9
            reseed()
        elseif c == d and d == e then
            gemlocations [3][j], gemlocations [4][j],  gemlocations [5][j] = 9,9,9
            reseed()
        elseif d == e and e == f then
            gemlocations [4][j],  gemlocations [5][j],  gemlocations [6][j] = 9,9,9
            reseed()
        end
    end

end

function reseed()
    for j = 1,6 do
        for i = 1,6 do
            if gemlocations [j][i] == 9 and j-1 ~= 0 then
                gemlocations [j][i] = gemlocations[j-1][i]
                gemlocations [j-1][i] = 9
                reseed()
            elseif gemlocations [j][i] == 9 then
                gemlocations [j][i] = flr(rnd(5)) + 1
            end
        end
    end
end


__gfx__
000000008888888899999999ffffffffbbbbbbbbccccccccdddddddd707070707070707000000000000000000000000000000000000000000000000000000000
000000008888888899999999ffffffffbbbbbbbbccccccccdddddddd070707070707070700000000000000000000000000000000000000000000000000000000
000000008888888899999999ffffffffbbbbbbbbccccccccdddddddd707070707070707000000000000000000000000000000000000000000000000000000000
000000008888888899999999ffffffffbbbbbbbbccccccccdddddddd070707070707070700000000000000000000000000000000000000000000000000000000
000000008888888899999999ffffffffbbbbbbbbccccccccdddddddd707070707070707000000000000000000000000000000000000000000000000000000000
000000008888888899999999ffffffffbbbbbbbbccccccccdddddddd070707070707070700000000000000000000000000000000000000000000000000000000
000000008888888899999999ffffffffbbbbbbbbccccccccdddddddd707070707070707000000000000000000000000000000000000000000000000000000000
000000008888888899999999ffffffffbbbbbbbbccccccccdddddddd070707070707070700000000000000000000000000000000000000000000000000000000
000000008888888899999999ffffffffbbbbbbbbccccccccdddddddd000000000000000000000000000000000000000000000000000000000000000000000000
000000008888888899999999ffffffffbbbbbbbbccccccccdddddddd000000000000000000000000000000000000000000000000000000000000000000000000
000000008888888899999999ffffffffbbbbbbbbccccccccdddddddd000000000000000000000000000000000000000000000000000000000000000000000000
000000008888888899999999ffffffffbbbbbbbbccccccccdddddddd000000000000000000000000000000000000000000000000000000000000000000000000
000000008888888899999999ffffffffbbbbbbbbccccccccdddddddd000000000000000000000000000000000000000000000000000000000000000000000000
000000008888888899999999ffffffffbbbbbbbbccccccccdddddddd000000000000000000000000000000000000000000000000000000000000000000000000
000000008888888899999999ffffffffbbbbbbbbccccccccdddddddd000000000000000000000000000000000000000000000000000000000000000000000000
000000008888888899999999ffffffffbbbbbbbbccccccccdddddddd000000000000000000000000000000000000000000000000000000000000000000000000
000000008888888899999999ffffffffbbbbbbbbccccccccdddddddd000000000000000000000000000000000000000000000000000000000000000000000000
000000008888888899999999ffffffffbbbbbbbbccccccccdddddddd000000000000000000000000000000000000000000000000000000000000000000000000
000000008888888899999999ffffffffbbbbbbbbccccccccdddddddd000000000000000000000000000000000000000000000000000000000000000000000000
000000008888888899999999ffffffffbbbbbbbbccccccccdddddddd000000000000000000000000000000000000000000000000000000000000000000000000
000000008888888899999999ffffffffbbbbbbbbccccccccdddddddd000000000000000000000000000000000000000000000000000000000000000000000000
000000008888888899999999ffffffffbbbbbbbbccccccccdddddddd000000000000000000000000000000000000000000000000000000000000000000000000
000000008888888899999999ffffffffbbbbbbbbccccccccdddddddd000000000000000000000000000000000000000000000000000000000000000000000000
000000008888888899999999ffffffffbbbbbbbbccccccccdddddddd000000000000000000000000000000000000000000000000000000000000000000000000
000000008888888899999999ffffffffbbbbbbbbccccccccdddddddd000000000000000000000000000000000000000000000000000000000000000000000000
000000008888888899999999ffffffffbbbbbbbbccccccccdddddddd000000000000000000000000000000000000000000000000000000000000000000000000
000000008888888899999999ffffffffbbbbbbbbccccccccdddddddd000000000000000000000000000000000000000000000000000000000000000000000000
000000008888888899999999ffffffffbbbbbbbbccccccccdddddddd000000000000000000000000000000000000000000000000000000000000000000000000
000000008888888899999999ffffffffbbbbbbbbccccccccdddddddd000000000000000000000000000000000000000000000000000000000000000000000000
000000008888888899999999ffffffffbbbbbbbbccccccccdddddddd000000000000000000000000000000000000000000000000000000000000000000000000
000000008888888899999999ffffffffbbbbbbbbccccccccdddddddd000000000000000000000000000000000000000000000000000000000000000000000000
000000008888888899999999ffffffffbbbbbbbbccccccccdddddddd000000000000000000000000000000000000000000000000000000000000000000000000
