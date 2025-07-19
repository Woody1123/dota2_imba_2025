if not _G.PrintTable then
    function PrintTable(t, indent)
        indent = indent or ""
        if type(t) ~= "table" then
            print(indent .. tostring(t))
            return
        end

        for k, v in pairs(t) do
            if type(v) == "table" then
                print(indent .. tostring(k) .. " = {")
                PrintTable(v, indent .. "    ")
                print(indent .. "}")
            else
                print(indent .. tostring(k) .. " = " .. tostring(v))
            end
        end
    end

    _G.PrintTable = PrintTable
end
