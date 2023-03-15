from pathlib2 import Path

import numpy as np
import pandas as pd

import xarray as xr
# import matplotlib.pyplot as plt

def get_student_date_site_sumclick_tensor(code_module, code_presentation_list=[], aggregate_sites=True,
                                          id_student_list=[], date_span=(None, None)):
    ''' INPUT: code_module - string, code_presentation - string, id_student - list, date_span = (begin, end)
    OUTPUT: numpy tensor with dimensions: 0 - id_student, 1 - date, 2 - id_site, 3 - sum_click
    operates on unprocessed studentVle.csv loaded with pandas.read_csv()
    '''
    tmp = pd.read_csv(Path(__file__).parent.parent/'data/studentVle.csv')
    print(tmp.shape)
    # tmp = tmp.loc[tmp[['id_student']].applymap(lambda x: x in id_student_list).values]
    # tmp = tmp.loc[
    # print(tmp[['code_presentation']].applymap(lambda x: x in code_presentation_list).values)
    # print(tmp[['code_presentation']])
    # ]

    # assume all students are included in studentVle
    # tmp = tmp.loc[tmp['code_module'] == code_module].loc[tmp[['code_presentation']].drop(columns=['code_module', 'code_presentation'])].set_index(['id_student', 'date', 'id_site'])
    # tmp = tmp.loc[tmp[['code_presentation']].applymap(lambda x: x in code_presentation_list).values]

    # tmp = tmp.groupby(level=tmp.index.names).sum()

    # if aggregate_sites:
    #     tmp = tmp.groupby(level=['id_student', 'date']).sum()

    # all_id_student = tmp.index.get_level_values('id_student').values
    # tmp = np.nan_to_num(tmp.squeeze().to_xarray().to_numpy(), copy=False, nan=0.0)

    # return all_id_student, tmp

# get_student_date_site_sumclick_tensor(code_module='DDD', code_presentation_list=['2013B', '2013J', '2014B', '2014J'],
#                                       id_student_list=)
#