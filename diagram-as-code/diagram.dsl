workspace {

    model {

        enterprise {

            customerPerson = person "Customer"

//            externalSystem = softwareSystem "IAM"  {
//                awsContainer = container "IAM"  {
//                    group "External Services Layer"  {
//                        policyComp = component "Authorization Policy" "Authentication and authorization" "Amazon Cognito" "External"
//                    }
//                }
//            }

            ecommerceSystem = softwareSystem "SGT - Sistema de Gerenciamento de Tarefas" {
                storeContainer = container "SGT SPA" "Front-End" "VueJS"
                dbContainer = container "Database" "Tasks Table" "Amazon DynamoDB" "Database"
                cacheContainer = container "Cache" "Redis" "Amazon Elasticache" "Cache"


                apiContainer = container "API" "Backend" "Spring Boot + Java 17" {


                    group "Web Layer" {
                        controllerComp = component "API Controller" "Requests, responses, routing and serialization" "Spring Boot"
                        mediatrComp = component "Spring MediatR" "Provides decoupling of requests and handlers" "Spring MediatR"
                    }
                    group "Application Layer" {
                        commandHandlerComp = component "Command Handler" "Business logic for changing state and triggering events" "Spring MediatR request handler"
                        queryHandlerComp = component "Query Handler" "Business logic for retrieving data" "Spring MediatR request handler"
                        commandValidatorComp = component "Command Validator" "Business validation prior to changing state" "Fluent Validation"
                    }
                    group "Infrastructure Layer" {
                        dbContextComp = component "DB Context" "ORM - Maps linq queries to the data store" "Hibernate"
                    }
                    group "Domain Layer" {
                        domainModelComp = component "Model" "Domain models" "poco classes"
                    }
                }
            }
        }

        iamSystem = softwareSystem "IAM - Identity and Access Management" "Amazon Cognito" "External"

        # relationships between people and software systems
        customerPerson -> storeContainer "Put Tasks" "https"

        # relationships to/from containers
        storeContainer -> apiContainer "uses" "https"
        apiContainer -> dbContainer "persists data" "https"


        # relationships to/from components
        dbContextComp -> dbContainer "stores data"
        dbContextComp -> cacheContainer "retrieves data"
        storeContainer -> controllerComp "calls"
        controllerComp -> iamSystem "authenticated and authorized by"
        controllerComp -> mediatrComp "sends queries & commands to"
        mediatrComp -> queryHandlerComp "sends query to"
        mediatrComp -> commandValidatorComp "sends command to"
        commandValidatorComp -> commandHandlerComp "passes command to"
        queryHandlerComp -> dbContextComp "Gets data from"
        commandHandlerComp -> dbContextComp "Update data in"
        dbContextComp -> domainModelComp "contains collections of"
    }

    views {

        systemContext ecommerceSystem "Context" {
            include *
            autoLayout
        }

        container ecommerceSystem "Container" {
            include *
            autoLayout
        }

        component apiContainer "Compoent" {
            include * customerPerson
            autoLayout
        }


        themes default "https://static.structurizr.com/themes/amazon-web-services-2023.01.31/theme.json"

        styles {
            # default overrides
            element "External" {
                background #999999
                color #ffffff
            }

            element "Database" {
                shape Cylinder
            }
            element "Browser" {
                shape WebBrowser
            }
            element "Cache" {
                shape Cylinder
                background #BD6057
            }
        }
    }
}