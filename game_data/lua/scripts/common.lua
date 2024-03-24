
function trunc(num)
    local n = num - mod(num, 1)
    return n
end

function round(num)
    local n = trunc(num + 0.5)
    return n
end

function ceil(num)
    local n = trunc(num + 0.99)
    return n
end

function power(a, n)
    local p = 1
    for i = 1,n do p = p * a end
    return p
end

function sign(n)
    if n < -1 then return -1
    elseif n > 1 then return 1
    else return n end
end

function abs(n)
	if n < 0 then return -n else return n end
end

function min(a, b)
    if a < b then return a else return b end
end

function max(a, b)
    if a > b then return a else return b end
end

function length(array)
	local count = 0
	for index, element in array do count = count + 1 end
	return count
end

function contains(array, sample)
	for index, element in array do
		if (element == sample) then return not nil end
	end
	return nil
end

function insert(array, sample)
	local index = length(array)
	array[index] = sample
end

function replace(array, sample, rep, all)
    for index, element in array do
		if (element == sample) then
			array[index] = rep
            if not all then return end
		end
	end
end

function remove(array, sample)
    local n = length(array)
    local j = 0
    for i = 0,n do
        if array[i] == sample then
            j = j + 1
        else
            array[i-j] = array[i]
        end
        array[i] = nil
    end
    array.n = n - j
end

RANDOM_SEED = 0
function random(a,b,seed)
    if (a == b) then return a end
    local min = min(a,b)
    local max = max(a,b)
    if seed ~= nil then RANDOM_SEED = RANDOM_SEED + seed end
    local diff = max - min
    local r = mod(RANDOM_SEED, diff+1)
    RANDOM_SEED = RANDOM_SEED + r - 1
    return min + r
end


function WaitForTutorialMessageBox()
	while IsTutorialMessageBoxOpen() do
		sleep(1)
	end
end

function close_file(fileName) end



NEUTRAL = 0
HAVEN = 1
PRESERVE = 2
INFERNO = 3
NECROPOLIS = 4
ACADEMY = 5
DUNGEON = 6
FORTRESS = 7
STRONGHOLD = 8


HUMAN = 0
COMPUTER = 1
OBSERVER = 2


EASY = 0
NORMAL = 0
HARD = 1
EXPERT = 2
IMPOSSIBLE = 2
DIFFICULTY_EASY = 0
DIFFICULTY_NORMAL = 1
DIFFICULTY_HARD = 2
DIFFICULTY_HEROIC = 3


WAR_MACHINE_BALLISTA = 1
WAR_MACHINE_CATAPULT = 2
WAR_MACHINE_FIRST_AID_TENT = 3
WAR_MACHINE_AMMO_CART = 4

