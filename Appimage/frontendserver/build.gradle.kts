plugins {
    kotlin("jvm") version "2.0.20"
    application
    id("com.gradleup.shadow") version "8.3.2"
}

group = "apps.chocolatecakecodes.localpiped"
version = "1.0"

repositories {
    mavenCentral()
}

dependencies {
    val ktorVersion = "2.3.12"
    implementation("io.ktor:ktor-server-core:$ktorVersion")
    implementation("io.ktor:ktor-server-netty:$ktorVersion")
    implementation("org.slf4j:slf4j-simple:2.0.16")
    
    testImplementation(kotlin("test"))
}

application {
    mainClass = "apps.chocolatecakecodes.localpiped.frontendserver.MainKt"
}

tasks.test {
    useJUnitPlatform()
}
kotlin {
    jvmToolchain(21)
}
