import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterModule } from '@angular/router';
import { PersonsComponent } from './persons/persons.component';


@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css'],
  
  standalone: true,
  imports: [
    CommonModule,
    RouterModule,
    PersonsComponent
  ]
})
export class AppComponent {
  title = 'angular-standalone-app';
}
