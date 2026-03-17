function kromozom = bos_olmayan_kromozom(kromozom)
% Kromozomda en az bir özellik seçili olmasını garanti eder.

if ~any(kromozom)
    kromozom(randi(numel(kromozom))) = 1;
end

end
