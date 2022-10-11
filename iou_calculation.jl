using CSV;
using DataFrames;
using DelimitedFiles;
using FilePaths;


function save_detection_to_df(folder_dir, is_prediction=false)::DataFrame
	txt_file_list = readdir(label_file_dir);
	let
		if !is_prediction
			labels_df = DataFrame(x1=Float16[],
					      x2=Float16[],
					      x3=Float16[],
					      x4=Float16[],
					      x5=Float16[],
					      file_name=Float16[]);
		else
			labels_df = DataFrame(x1=Float16[],
					      x2=Float16[],
					      x3=Float16[],
					      x4=Float16[],
					      x5=Float16[],
					      x6=Float16[],
					      file_name=Float16[]);
		end
		for txt_file in txt_file_list 
			current_file = string(joinpath(folder_dir, txt_file))
			try
				lines_df = DataFrame(readdlm(current_file, Float16), :auto);
				lines_df[:, :file_name] .= txt_file;
				labels_df = vcat(labels_df, lines_df);
			catch
				println("File $current_file has no lines, or an error occured while reading it!")
			end
		end
		return labels_df
	end
end


function calculate_iou(image_list, y_df, y_hat_df)
	for single_img in image_list
		label_file = chop(single_img, tail=4)*".txt";
		temp_rows_true = y_df[in([label_file]).(y_df.file_name), :];
		temp_rows_pred = y_hat_df[in([label_file]).(y_hat_df.file_name), :];
		println(temp_rows_true)
		println(temp_rows_pred)
	end
	
end

label_file_dir = p"/home/ebz/Desktop/emre/jl_projects/weap_test_1/obj_train_data/labels/"
# Read every file name in the folder and save them as array
true_label_df = save_detection_to_df(label_file_dir)

detection_file_dir = p"/home/ebz/Desktop/emre/yolov5/runs/detect/weap_detection/labels"
predicted_label_df = save_detection_to_df(detection_file_dir, true)

img_folder = p"/home/ebz/Desktop/emre/jl_projects/weap_test_1/obj_train_data/images/"
img_name_list = readdir(img_folder)
calculate_iou(img_name_list, true_label_df, predicted_label_df)
