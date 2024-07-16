import { AfterViewInit, Component, ElementRef, Inject, OnInit, PLATFORM_ID, ViewChild } from '@angular/core';
import { CommonModule, isPlatformBrowser } from '@angular/common';
import { ReactiveFormsModule, FormGroup, FormBuilder, Validators } from '@angular/forms';
import { HttpClientModule } from '@angular/common/http';
import { Person } from '../models/person.model';
import { PersonService } from '../services/person.service';
import { DOCUMENT } from '@angular/common';
import { AuthService } from '../services/auth.service';
import { Router } from '@angular/router';

declare var bootstrap: any;

@Component({
  selector: 'app-persons',
  standalone: true,
  imports: [CommonModule, HttpClientModule, ReactiveFormsModule], // Adicione HttpClientModule aqui
  templateUrl: './persons.component.html',
  styleUrls: ['./persons.component.css'],
  providers: [PersonService, AuthService]
})
export class PersonsComponent implements OnInit {
  people: Person[] = [];
  selectedPerson: Person | null = null;
  newPersonForm: FormGroup;
  editPersonForm: FormGroup;
  loginForm: FormGroup;
  currentPage: number = 1;
  totalPages: number = 1;
  totalRecords: number = 0;
  loading = false;
  submitted = false;
  error = '';

  currentId: number | undefined;

  @ViewChild('modalNewRegister') myModal: ElementRef | undefined;

  constructor(
    private personService: PersonService,
    private fb: FormBuilder,
    private authService: AuthService,
    private router: Router,
    @Inject(DOCUMENT) private document: Document,
    @Inject(PLATFORM_ID) private platformId: any
  ) {
    this.newPersonForm = this.fb.group({
      name: ['', Validators.required],
      email: ['', [Validators.required, Validators.email]],
      phone: ['', Validators.required],
      birth_date: ['', Validators.required]
    });

    this.editPersonForm = this.fb.group({
      name: ['', Validators.required],
      email: ['', [Validators.required, Validators.email]],
      phone: ['', Validators.required],
      birth_date: ['', Validators.required]
    });

    this.loginForm = this.fb.group({
      email: ['', [Validators.required, Validators.email]],
      password: ['', Validators.required],
    });
  }

  ngOnInit(): void {
    if (this.isBrowser()) {
      if (this.authService.isAuthenticated()) {
        this.loadInit();
      } else {
        this.modalAuth();
      }
    }
  }

  private isBrowser(): boolean {
    return isPlatformBrowser(this.platformId);
  }

  loadInit() {
    this.loadPeople();
  }

  modalAuth() {
    this.openModalStatic('modalAuth');
  }

  loadPeople(page: number = 1): void {
    this.personService.getPeople(page).subscribe((data: any) => {
      this.people = data.people;
      this.currentPage = page;
      this.totalRecords = data.total_records;
      this.totalPages = data.total_pages;
    });
  }

  selectPerson(person: Person): void {
    this.selectedPerson = { ...person };
    this.editPersonForm.patchValue(this.selectedPerson);
  }

  createPerson(): void {
    if (this.newPersonForm.valid) {
      this.personService.createPerson(this.newPersonForm.value).subscribe(person => {
        this.people.push(person);
        this.newPersonForm.reset();
        this.loadPeople(this.currentPage);
        this.openModal('modalNewRegisterSucess');
        this.closeModal('modalNewRegister');
      });
    }
  }

  updatePerson(): void {
    if (this.selectedPerson && this.editPersonForm.valid) {
      this.personService.updatePerson({ ...this.selectedPerson, ...this.editPersonForm.value }).subscribe(() => {
        this.loadPeople(this.currentPage);
        this.selectedPerson = null;
        this.closeModal('modalEditRegister');
        this.openModal('modalNewRegisterEditS');
      });
    }
  }

  deletePerson(id: number | undefined): void {
    if (id) {
      this.personService.deletePerson(id).subscribe(() => {
        this.loadPeople(this.currentPage);
      });
    }
  }

  closeModal(id: string) {
    const modalElement = this.document.getElementById(id);
    if (modalElement) {
      const modalInstance = bootstrap.Modal.getInstance(modalElement);
      if (modalInstance) {
        modalInstance.hide();
      }
    }
  }

  openModal(id: string) {
    if (this.isBrowser()) {
      const modalElement = this.document.getElementById(id);
      if (modalElement && (window as any).bootstrap) {
        const bootstrap = (window as any).bootstrap;
        const modalInstance = new bootstrap.Modal(modalElement);
        modalInstance.show();
      }
    }
  }

  openModalStatic(id: string): void {
    if (this.isBrowser()) {
      const modalElement = this.document.getElementById(id);
      if (modalElement && (window as any).bootstrap) {
        const bootstrap = (window as any).bootstrap;
        const modalInstance = new bootstrap.Modal(modalElement, {
          backdrop: 'static',
          keyboard: false
        });
        modalInstance.show();
      }
    }
  }

  nextPage(): void {
    if (this.currentPage < this.totalPages) {
      this.loadPeople(this.currentPage + 1);
    }
  }

  login(): void {
    this.submitted = true;

    if (this.loginForm.invalid) {
      return;
    }

    this.loading = true;
    const { email, password } = this.loginForm.value;
    this.authService.login(email, password)
      .subscribe(
        data => {
          this.closeModal('modalAuth');
          this.loadInit();
        },
        error => {
          this.error = error;
          this.loading = false;
        });
  }

  previousPage(): void {
    if (this.currentPage > 1) {
      this.loadPeople(this.currentPage - 1);
    }
  }

  get name() { return this.newPersonForm.get('name'); }
  get email() { return this.newPersonForm.get('email'); }
  get phone() { return this.newPersonForm.get('phone'); }
  get birth_date() { return this.newPersonForm.get('birth_date'); }
  get password() { return this.loginForm.get('password'); }
}
