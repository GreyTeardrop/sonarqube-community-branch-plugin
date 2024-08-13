ARG SONARQUBE_VERSION

FROM bellsoft/liberica-openjdk-alpine-musl:17.0.12 AS builder

COPY . /home/build/project
WORKDIR /home/build/project
RUN ./gradlew build -x test

FROM sonarqube:${SONARQUBE_VERSION}
COPY --from=builder --chown=sonarqube:sonarqube /home/build/project/build/libs/sonarqube-community-branch-plugin-*.jar /opt/sonarqube/extensions/plugins/

ARG PLUGIN_VERSION
ENV PLUGIN_VERSION=${PLUGIN_VERSION}
ENV SONAR_WEB_JAVAADDITIONALOPTS="-javaagent:./extensions/plugins/sonarqube-community-branch-plugin-${PLUGIN_VERSION}.jar=web"
ENV SONAR_CE_JAVAADDITIONALOPTS="-javaagent:./extensions/plugins/sonarqube-community-branch-plugin-${PLUGIN_VERSION}.jar=ce"
