function dataset = DatasetName(filename)
findex = findstr(filename,'.');
dataset = filename(1:(findex-1));
dataset = upper(dataset);
return;
