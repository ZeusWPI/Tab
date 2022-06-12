import requests


base_url = 'http://localhost:3000'
user = 'j'
user_token = '1idEG5bFVVjUcl+15Y1DsQ=='

headers = {'Authorization': f'Token token={user_token}'}

data = {
    'transaction': {
        'euros': 5.0,
        'message': 'Transaction from Python',
        'debtor': user,
        'creditor': 'silox'
    }
}

r = requests.post((base_url + f'/api/v1/transactions.json'), headers=headers, json=data)
print(r.text)
