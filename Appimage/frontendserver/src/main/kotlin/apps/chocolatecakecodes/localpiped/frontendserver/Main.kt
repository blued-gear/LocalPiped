package apps.chocolatecakecodes.localpiped.frontendserver

import io.ktor.server.engine.embeddedServer
import io.ktor.server.http.content.singlePageApplication
import io.ktor.server.http.content.vue
import io.ktor.server.netty.Netty
import io.ktor.server.routing.routing

fun main(args: Array<String>) {
    embeddedServer(Netty, port = 8171) {
        this.routing {
            this.singlePageApplication {
                this.useResources = false
                vue("./share/frontend")
            }
        }
    }.start(true)
}
