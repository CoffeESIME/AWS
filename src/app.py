def extract():    
    return 'Extracting data from'

def transform():
    return 'Transforming data from'

def load():
    print('Loading data from')
    
def etl():
    extract()
    transform()
    load()

def handler(event, context):
    etl()
    return {
        'statusCode': 200,
        'body': 'ETL job completed'
    }
