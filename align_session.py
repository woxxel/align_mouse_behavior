import sys
## change import path (was in subfolder before)
from align_behavior_data import *

_, datapath_in, datapath_out, dataset, mouse, session = sys.argv

align_data_on_hpc(datapath_in,datapath_out,dataset,mouse,session)
