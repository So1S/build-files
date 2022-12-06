import os
import bentoml
from bentoml.io import Text, IODescriptor
import prepared
import utils

input_type = utils.get_data_type(os.environ['INPUT_TYPE'])
output_type = utils.get_data_type(os.environ['OUTPUT_TYPE'])
model_name = os.environ['MODEL_NAME']
library = os.environ['LIBRARY']

global artifacts
artifacts = None
svc = bentoml.Service(model_name)

@svc.api(input=input_type, output=output_type)
def predict(input):
    global artifacts
    if artifacts is None:
        load("load")
    return prepared.run(artifacts, input)

@svc.api(input=Text(), output=Text())
def load(input):
    global artifacts
    if artifacts is None:
        artifacts = prepared.load_artifacts()
    return "load success"