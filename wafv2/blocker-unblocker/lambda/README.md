# How to test

## Unit Tests

Run the tests using `pytest`. You will need `pytest`, `pytest-cov` and `pytest-socket` to run the tests.

The tests also use the `moto` library to mock AWS services without requiring actual resources. The `--disable-socket` option provided by `pytest-socket` ensures that no network traffic leaves the local testing environment (i.e. ensures AWS APIs are not actually being called)

1. You will first need to setup a virtual environment to install the requirements:

    ```sh
    python3 -m venv virtualenv
    source ./virtualenv/bin/activate
    pip install -r requirements.txt
    ```

2. Run the tests

    ```sh
    cd lambda
    pytest -v --disable-socket --cov -s tests.py
    ```

## Integration Testing

Testing the module against real AWS services is most easily acheived by creating, via Terraform, an instance of the module in a dev/testing environment, sending messages to the SNS topic, and checking the Lambda invocation logs.
