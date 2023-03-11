import numpy as np
import pandas as pd
import xarray as xr
# import matplotlib.pyplot as plt

def get_student_date_site_sumclick_tensor(code_module=None, code_presentation=None, aggregate_sites=True,
                                          id_student=None, date_span=(None, None), data_path='data/source_data'):
    ''' INPUT: code_module - string, code_presentation - string, id_student - list, date_span = (begin, end)
    OUTPUT: numpy tensor with dimensions: 0 - id_student, 1 - date, 2 - id_site, 3 - sum_click
    operates on unprocessed studentVle.csv loaded with pandas.read_csv()
    '''
    tmp = pd.read_csv(path + '/studentVle.csv')
    if id_student != None:
        tmp = tmp.loc[tmp['id_student'] in id_student]

    tmp = tmp.loc[tmp['code_module'] == code_module].loc[tmp['code_presentation'] == code_presentation].drop(
        columns=['code_module', 'code_presentation']).set_index(['id_student', 'date', 'id_site'])
    tmp = tmp.groupby(level=tmp.index.names).sum()

    if aggregate_sites:
        tmp = tmp.groupby(level=['id_student', 'date']).sum()

    all_id_student = tmp.index.get_level_values('id_student').values
    tmp = np.nan_to_num(tmp.squeeze().to_xarray().to_numpy(), copy=False, nan=0.0)

    return all_id_student, tmp


def get_nice_data_pd(code_module, code_presentation):
    query_params = {"code_module": code_module, "code_presentation": code_presentation}

    courses = pd.read_csv('data/source_data/courses.csv')
    assessments = pd.read_csv('data/source_data/assessments.csv')
    vle = pd.read_csv('data/source_data/vle.csv')
    studentInfo = pd.read_csv('data/source_data/studentInfo.csv')
    studentRegistration = pd.read_csv('data/source_data/studentRegistration.csv')
    studentAssessment = pd.read_csv('data/source_data/studentAssessment.csv')
    studentVle = pd.read_csv('data/source_data/studentVle.csv')

    aids, sdsst_0 = get_student_date_site_sumclick_tensor(query_params['code_module'], query_params['code_presentation'])

    module_length = courses.loc[courses['code_module'] == query_params['code_module']].loc[courses['code_presentation'] == query_params['code_presentation']].drop(columns=['code_module', 'code_presentation']).values[0][0]
    assessments_hier = assessments.loc[assessments['code_module'] == query_params['code_module']].loc[assessments['code_presentation'] == query_params['code_presentation']].drop(columns=['code_module', 'code_presentation']).set_index(['id_assessment'])
    vle_hier = vle.loc[vle['code_module'] == query_params['code_module']].loc[vle['code_presentation'] == query_params['code_presentation']].drop(columns=['code_module', 'code_presentation']).set_index(['id_site'])
    studentInfo_hier = studentInfo.loc[studentInfo['code_module'] == query_params['code_module']].loc[studentInfo['code_presentation'] == query_params['code_presentation']].drop(columns=['code_module', 'code_presentation']).set_index(['id_student'])
    studentRegistration.loc[studentRegistration['code_module'] == query_params['code_module']].loc[studentRegistration['code_presentation'] == query_params['code_presentation']].drop(columns=['code_module', 'code_presentation']).set_index(['id_student'])
    studentAssessment_hier = studentAssessment.loc[studentAssessment[['id_assessment']].applymap(lambda x: x in assessments_hier.index.values)['id_assessment'].values].set_index(['id_student', 'id_assessment'])

