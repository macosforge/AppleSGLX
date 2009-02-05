#include <stdio.h>
#include <stdlib.h>
#include <GL/glut.h>
#include <GL/glext.h>
#include <GL/gl.h>

void initialize(void) {
    glEnable(GL_DEPTH_TEST);
}

void reshape(int width, int height) {
    glViewport(0, 0, width, height);
    glutPostRedisplay();
}

void display(void) {
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    glLoadIdentity();	
    glBegin(GL_TRIANGLES);
    glVertex3f( 0.0f, 1.0f, 0.0f);
    glVertex3f(-1.0f,-1.0f, 0.0f);
    glVertex3f( 1.0f,-1.0f, 0.0f);
    glEnd();	
    glFlush();
}

int main(int argc, char *argv[]) {
    int win;
    glutInit(&argc, (char **)argv);
    glutInitDisplayMode(GLUT_RGB | GLUT_DEPTH); 
    glutInitWindowSize(800, 600);
    win = glutCreateWindow("Test");
    
    initialize();

    glutReshapeFunc(reshape);
    glutDisplayFunc(display);

    glutMainLoop();

    return EXIT_FAILURE;
}