function model = random_forest(x, y)

	tempDir = tempname;

	% Write input data to temp dir
	mkdir(tempDir);
	dlmwrite([tempDir '/' 'xData.tsv'], x, 'delimiter', '\t');
	dlmwrite([tempDir '/' 'yData.tsv'], y, 'delimiter', '\t');

	% Run random forest
	[ownFolder, ownName] = fileparts(mfilename('fullpath'));
	[status, result] = system([ownFolder, '/', ['run_forest.R', ' --tempdir ', tempDir]])

	% Read metadata
	metadata = read_meta_file(tempDir, 'metadata.txt');

	% Create output struct
	model = struct;

	model.bestvar 	   = read_mat_tsv(tempDir, 'forest_bestvar.tsv');
	model.classwt	   = NaN; % Not implemented
	model.cutoff       = read_mat_tsv(tempDir, 'forest_cutoff.tsv');
	model.errtr        = read_mat_tsv(tempDir, 'err_rate.tsv');
	model.errts		   = NaN; % Not implemented
	model.importance   = read_mat_tsv(tempDir, 'importance.tsv');
	model.importanceSD = NaN; % Not implemented
	model.inbag 	   = NaN; % Not implemented
	model.localImp	   = NaN; % Not Implemented
	model.mtry 		   = metadata.mtry;
	model.nclass	   = metadata.nclass;
	model.ndbigtree    = read_mat_tsv(tempDir, 'forest_ndbigtree.tsv');
	model.new_labels   = NaN; % Not implemented
	model.nodeclass    = NaN; % Not implemented
	model.nodestatus   = read_mat_tsv(tempDir, 'forest_nodestatus.tsv');
	model.nrnodes	   = metadata.nrnodes;
	model.ntree  	   = metadata.ntree;
	model.oob_times    = read_mat_tsv(tempDir, 'oob_times.tsv');
	model.orig_labels  = NaN; % Not implemented
	model.outcl		   = NaN; % Not implemented
	model.outclts      = NaN; % Not implemented
	model.proximity    = NaN; % Not implemented
	model.treemap      = reshape_treemap(read_mat_tsv(tempDir, 'forest_treemap.tsv'));
	model.votes 	   = read_mat_tsv(tempDir, 'votes.tsv');
	model.xbestsplit   = read_mat_tsv(tempDir, 'forest_xbestsplit.tsv');

	% Unused var?
	%predicted  = read_str_file(tempDir, 'predicted.tsv');
	%y          = read_str_file(tempDir, 'y.tsv');
	%nodepred   = read_mat_tsv(tempDir, 'forest_nodepred.tsv');
	%pid        = read_mat_tsv(tempDir, 'forest_pid.tsv');
	%classes    = read_str_file(tempDir, 'classes.tsv');
	%confusion  = read_mat_tsv(tempDir, 'confusion.tsv');

	rmdir(tempDir, 's');
end

function reshapedTreeMap = reshape_treemap(treemap)
	reshapedTreeMap = NaN(size(treemap));
	for i = 1:size(treemap,2) / 2
		ind = (i*2)-1;
		left = treemap(:,ind); right = treemap(:,ind+1);
		reshaped = reshape([left right]', [], 2); 
		reshapedTreeMap(:,ind:ind+1) = reshaped;
	end 
end

function out = read_mat_tsv(tempDir, fileName)
	out = dlmread([tempDir '/' fileName], '\t');
end

function str = read_str_file(tempDir, fileName)
	fId = fopen([tempDir '/' fileName]);
	strCell = textscan(fId, '%s');
	str = strrep(strCell{1},'"','');
	fclose(fId);
end

function str = read_meta_file(tempDir, fileName)
	fileID = fopen([tempDir '/' 'metadata.tsv']);

	fieldNames = textscan(fgetl(fileID), '%s');
	fieldNames = fieldNames{1};

	values = textscan(fgetl(fileID), '%s');
	values = values{1};

	str = struct;
	fieldNames = strrep(fieldNames, '"', '');
	for i = 1:length(fieldNames)
		fieldName = values{i}(2:end-1);
		if values{i}(1) == '"' && values{i}(end) == '"'
			value = strrep(values{i}, '"', '');
		else
			value = str2num(values{i});	
		end
		str = setfield(str, fieldNames{i}, value);
	end
end