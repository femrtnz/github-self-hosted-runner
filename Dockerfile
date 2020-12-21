FROM ubuntu:18.04

ENV RUNNER_VERSION=2.263.0

RUN useradd -m actions
RUN apt-get -yqq update && apt-get install -yqq curl jq wget

RUN \
  LABEL="$(curl -s -X GET 'https://api.github.com/repos/actions/runner/releases/latest' | jq -r '.tag_name')" \
  RUNNER_VERSION="$(echo ${LABEL} | cut -c 2- )" &&\
  cd /home/actions && mkdir actions-runner && cd actions-runner &&\
  wget https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz && pwd && ls -la &&\
  tar xzf /home/actions/actions-runner/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz -C /home/actions/actions-runner && pwd && ls -la /home/actions/actions-runner/

WORKDIR /home/actions/actions-runner

COPY entrypoint.sh .

RUN chown -R actions /home/actions && /home/actions/actions-runner/bin/installdependencies.sh
RUN chmod 500 /home/actions/actions-runner/entrypoint.sh

USER actions
ENTRYPOINT ["./entrypoint.sh"]
