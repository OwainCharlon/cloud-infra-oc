# start by pulling the python image
FROM python:3.8-alpine

# copy the app files into the image
COPY ./voting-app/vote/ /vote/

# switch working directory
WORKDIR /vote

# install the dependencies and packages in the requirements file
RUN pip install -r requirements.txt

# configure the container to run in an executed manner
ENTRYPOINT [ "python" ]

CMD ["app.py" ]