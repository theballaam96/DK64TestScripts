function CycleRNG(oldRNGValue)
    local mutliplicationResult = oldRNGValue * 0x01DF5E0D;
    local lower32 = bit.band(multiplicationResult, 0xFFFFFFFF); -- Lower 32 bits
    local newRNGValue = bit.band(lower32 + 1, 0xFFFFFFFF);
    return newRNGValue;
end