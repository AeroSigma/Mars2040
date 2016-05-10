NewMorph = cell(0);
for i = 1:length(Morph)
    Cur_Arch = Morph{i};
    Cur_Arch.Index = i;
    Morph{i} = Cur_Arch;
end