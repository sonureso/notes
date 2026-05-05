> # 1. Path Parameters:
Path Parameters are dynamic segments of a url path used to identify a specific resource.

To improve the path parameters API docs, we can use Path() function and add description, examples, etc,.

### Path() Function:
The Path() Function is FastAPI is used to provide metadata, validation, rules and documentation hints for path parameters in your API endpoints.
For Example:
- Title: A title for the parameter, which will be used in the API documentation.
- Description: A description of the parameter, which will also be used in the API documentation.
- Example: An example value for the parameter, which can be shown in the API documentation.
- Validation: You can specify validation rules for the parameter, such as minimum and maximum values, regex patterns, etc.
- (...): The ellipsis (...) is used to indicate that the parameter is required. If you want to make it optional, you can provide a default value instead.
```python
@app.get('/patient/{patient_id}')
def view_patient(patient_id: str = Path(..., description='ID of the patient in the DB', example='P001')):
    data = load_data()
    if patient_id in data:
        return data[patient_id]
    raise HTTPException(status_code=404, detail='Patient not found')
```

### HTTP status codes:
HTTP status codes are 3-digit numbers retruned by web server (like FastAPI) to indicate the result of a client request. Examples:
- 2xx: Success (e.g., 200 OK, 201 Created)
- 4xx: Client Errors (e.g., 400 Bad Request, 404 Not Found)
- 5xx: Server Errors (e.g., 500 Internal Server Error)

### HTTPException:
HTTPException is a special built-in exception in FastAPI used to respond custom HTTP error responses when something goes wrong in your API.

Instead of returning a normal response, you can raise an error with 
- a proper HTTP status code (like 400, 404, etc.)
- a custom error message
- and optionally, additional details in the response body.
```Python 
if patient_id in data:
    return data[patient_id]
raise HTTPException(status_code=404, detail='Patient not found')
```

### Query Parameters:
Query parameters are additional parameters that can be included in the URL of an API request to provide extra information or filter results. They are typically used for optional parameters that modify the behavior of an endpoint without changing the endpoint's path.
For example: /patients?age=30&gender=male
- The ? indicates the start of query parameters.
- Each parameter is a key-value pair, separated by an equals sign (=).
- Multiple parameters are separated by an ampersand (&).

**Query()** is a function in FastAPI that allows you to define and validate query parameters for your API endpoints. It provides similar functionality to Path(), but is specifically designed for query parameters.
```python 
@app.get('/sort')
def sort_patients(sort_by: str = Query(..., description='Sort on the basis of height, weight or bmi'), order: str = Query('asc', description='sort in asc or desc order')):
    valid_fields = ['height', 'weight', 'bmi']
    if sort_by not in valid_fields:
        raise HTTPException(status_code=400, detail=f'Invalid field select from {valid_fields}')
    if order not in ['asc', 'desc']:
        raise HTTPException(status_code=400, detail='Invalid order select between asc and desc')

    data = load_data()
    sort_order = True if order=='desc' else False
    sorted_data = sorted(data.values(), key=lambda x: x.get(sort_by, 0), reverse=sort_order)
    return sorted_data
```

### Response Models:
Response models in FastAPI defines the structure of the data that your endpoint will return. It helps in:
- Generating clean API Docs.
- Validating the response data.
- Filtering unnecessary data from the response.