#!/bin/bash
#*******************************************************************************
#   Copyright 2017 IBM Corp. All Rights Reserved.
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#        http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.
#*******************************************************************************

set -e

find . -name '*.sh' -exec shellcheck {} +

echo "verify JanusGraphSchemaImporter"
mkdir files && cp -r samples files/ && cp -r test files/ && cp -r src files/ \
    && docker run --rm -ti -v "$(pwd)"/files:/home/janusgraph/janusgraph/files \
        yihongwang/janusgraph-console bin/gremlin.sh -e files/test/SchemaImporterTest.groovy \
    && rm -rf files

echo "verify Data generator"

mvn package \
    && ./run.sh gencsv csv-conf/tiny_config.json /tmp
