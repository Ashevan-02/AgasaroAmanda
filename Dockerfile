FROM openjdk:17

WORKDIR /app

# Copy source code
COPY ./src ./src

# Create a folder for compiled .class files
RUN mkdir classes

# Compile Java files into /app/classes
RUN javac -d classes src/casestudy/*.java src/casestudy2/*.java src/casestudy3/*.java

# Default main class
CMD ["java", "-cp", "classes", "casestudy.RealConstructorMain"]
