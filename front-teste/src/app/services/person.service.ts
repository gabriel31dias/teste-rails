import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders, HttpParams } from '@angular/common/http';
import { Observable } from 'rxjs';
import { Person } from '../models/person.model';
import { environment } from '../../environment';

@Injectable({
  providedIn: 'root'
})
export class PersonService {
  private apiUrl = environment.base_url_api + '/persons';

  constructor(private http: HttpClient) { }

  private getAuthHeaders(): HttpHeaders {
    const storedUser = localStorage.getItem('currentUser');
    const token = storedUser ? JSON.parse(storedUser).token : null;
    let headers = new HttpHeaders();
    if (token) {
      headers = headers.set('Authorization', `Bearer ${token}`);
    }
    return headers;
  }

  getPeople(page: number = 1): Observable<Person[]> {
    const params = new HttpParams().set('page', page.toString());
    const headers = this.getAuthHeaders();
    return this.http.get<Person[]>(this.apiUrl, { params, headers });
  }

  getPerson(id: number): Observable<Person> {
    const headers = this.getAuthHeaders();
    return this.http.get<Person>(`${this.apiUrl}/${id}`, { headers });
  }

  createPerson(person: Person): Observable<Person> {
    const headers = this.getAuthHeaders();
    return this.http.post<Person>(this.apiUrl, person, { headers });
  }

  updatePerson(person: Person): Observable<Person> {
    const headers = this.getAuthHeaders();
    return this.http.put<Person>(`${this.apiUrl}/${person.id}`, person, { headers });
  }

  deletePerson(id: number): Observable<void> {
    const headers = this.getAuthHeaders();
    return this.http.delete<void>(`${this.apiUrl}/${id}`, { headers });
  }
}
