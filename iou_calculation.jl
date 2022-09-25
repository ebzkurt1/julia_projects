using CSV;
using DataFrames;
using DelimitedFiles;
using FilePaths;

label_file_dir = p"/home/ebz/Desktop/emre/jl_projects/weap_test_1/obj_train_data/labels/"
# Read every file name in the folder and save them as array
label_txt_list = readdir(label_file_dir);
labels_df = DataFrame(x1=Float16[],x2=Float16[],x3=Float16[],x4=Float16[],x5=Float16[],file_name=Float16[]);
for txt_file in label_txt_list  # Itrate through the files
	current_file = string(joinpath(label_file_dir, txt_file))
	#= 
	# The function readdlm throughs an error if the file it reads is empty.
	# So, to overcome this error a try/catch is implemented. Only the files with
	# a detection is readed.\
	=#
	try
		# Read label txt file as dataframe
		lines_df = DataFrame(readdlm(current_file, Float16), :auto);
		# Add the label file name as a column
		lines_df[:, :file_name] .= txt_file;
		global labels_df = vcat(labels_df, lines_df);
	catch
		println("File $current_file has no lines, or an error occured while reading it!")
	end
end
println(labels_df)
