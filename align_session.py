import sys
## change import path (was in subfolder before)
from align_behavior import *

_, server_path, dataset, mouse, session = sys.argv

align_data(server_path,dataset,mouse,session)
