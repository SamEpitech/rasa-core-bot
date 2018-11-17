help:
	@echo "    train-core"
	@echo "        Train a dialogue model using Rasa core."
	@echo "    run-core"
	@echo "        Spin up the core server on the command line"
	@echo "    run-actions"
	@echo "        Spin up the action server"
	@echo "    run"
	@echo "        Spin up both core and the action server"
	@echo "    visualize"
	@echo "        Show your stories as a graph"


train-core:
	python -m rasa_core.train -s data/stories.md -d domain.yml -o models/dialogue -c ./default_config.yml --debug

run-core:
	python -m rasa_core.run --core models/dialogue --nlu models/nlu/current --debug --endpoints endpoints.yml

run-actions:
	python -m rasa_core_sdk.endpoint --actions actions

run:
	make run-actions&
	make run-core

api:
	 make run-actions&
	 python -m rasa_core.run --enable_api --core models/dialogue --nlu models/nlu/current --cors 'http://localhost:1337' --endpoints endpoints.yml --debug

train-interactive:
	python -m rasa_core.train interactive -s data/stories.md -d domain.yml -o models/dialogue -c ./default_config.yml --debug --endpoints endpoints.yml

visualize:
	python -m rasa_core.visualize -s data/stories.md -d domain.yml -o story_graph.png

train-nlu:
	python -m rasa_nlu.train -c nlu_tensorflow.yml --fixed_model_name current --data data/nlu_data.md -o models --project nlu --verbose

kill-port-already-in-use:
	sudo lsof -t -i tcp:5055 | xargs kill -9

train-both-nlu-core:
	python -m rasa_nlu.train -c nlu_tensorflow.yml --fixed_model_name current --data ./data/nlu_data.md -o models --project nlu --verbose&
	python -m rasa_core.train -s ./data/stories.md -d domain.yml -o models/dialogue -c ./default_config.yml --debug
