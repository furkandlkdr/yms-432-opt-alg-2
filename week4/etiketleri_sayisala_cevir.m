function y = etiketleri_sayisala_cevir
% Etiketleri ikili sayısal değere çevirir: g -> 1, b -> 0.

global Y
etiketler = Y;

if isnumeric(etiketler) || islogical(etiketler)
    y = double(etiketler(:));
    if ~all(ismember(unique(y), [0, 1]))
        y = double(y == max(y));
    end
    return;
end

if iscell(etiketler)
    etiketMetni = string(etiketler(:));
elseif isstring(etiketler)
    etiketMetni = etiketler(:);
elseif ischar(etiketler)
    etiketMetni = string(cellstr(etiketler));
elseif iscategorical(etiketler)
    etiketMetni = string(etiketler(:));
else
    error('Y için desteklenmeyen etiket türü.');
end

y = double(strcmpi(etiketMetni, "g"));

end
