
PWD := ${CURDIR}

all: flatten json_merge process_replaypack rename_files package_dataset

flatten:
	docker run \
		-v "${PWD}/processing:/sc2-dataset-preparator/processing" \
		sc2-dataset-preparator \
		python3 directory_flattener.py

json_merge:
	docker run \
		-v "${PWD}/processing:/sc2-dataset-preparator/processing" \
		sc2-dataset-preparator \
		python3 json_merger.py \
		--json_one=../processing/json_merger/map_translation.json \
		--json_two=../processing/json_merger/new_maps_processed.json


download_maps:
	docker run \
		-v "${PWD}/processing:/sc2-dataset-preparator/processing" \
		sc2-dataset-preparator \
		python3 sc2_map_downloader.py


process_replaypack:
	docker run \
		-v "${PWD}/processing:/sc2-dataset-preparator/processing" \
		sc2-dataset-preparator \
		python3 sc2_replaypack_processor.py \
		--n_processes 8 \
		--perform_chat_anonymization "true"

rename_files:
	docker run \
		-v "${PWD}/processing:/sc2-dataset-preparator/processing" \
		sc2-dataset-preparator \
		python3 file_renamer.py \
		--input_dir ../processing/sc2_replaypack_processor/output


package_reset_dataset:
	docker run \
		-v "${PWD}/processing:/sc2-dataset-preparator/processing" \
		sc2-dataset-preparator \
		python3 file_packager.py --input_dir ../processing/directory_flattener/output

package_dataset:
	docker run \
		-v "${PWD}/processing:/sc2-dataset-preparator/processing" \
		sc2-dataset-preparator \
		python3 file_packager.py

build:
	docker build . -t sc2-dataset-preparator
