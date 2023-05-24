FROM public.ecr.aws/lambda/python:3.10

WORKDIR /app

COPY src/ ${LAMBDA_TASK_ROOT}
# Run app.py when the container launches
CMD ["app.handler"]
