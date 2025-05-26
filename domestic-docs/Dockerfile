# Generating pdf for user manuals
FROM debian:12.8 AS manuals-generation-stage
WORKDIR /manuals
COPY ./build/ ./build/
COPY ./docs/ ./docs/
COPY ./assets/ ./assets/
RUN ./build/build.sh

# Exporting
FROM scratch AS export-stage
COPY --from=manuals-generation-stage /manuals/build/target/*.pdf /