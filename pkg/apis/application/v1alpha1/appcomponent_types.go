package v1alpha1

import (
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
)

// EDIT THIS FILE!  THIS IS SCAFFOLDING FOR YOU TO OWN!
// NOTE: json tags are required.  Any new fields you add must have json tags for the fields to be serialized.

// AppComponentSpec defines the desired state of AppComponent
// +k8s:openapi-gen=true
type AppComponentSpec struct {
	// +kubebuilder:validation:MaxLength=50
	// +kubebuilder:validation:MinLength=1
	Name string `json:"name"`

	// +kubebuilder:validation:MaxLength=50
	// +kubebuilder:validation:MinLength=1
	TemplateId string `json:"templateId"`

	// +kubebuilder:validation:MaxLength=50
	// +kubebuilder:validation:MinLength=1
	ApplicationID string `json:"applicationId"`

	// +kubebuilder:validation:MaxLength=50
	// +kubebuilder:validation:MinLength=1
	CustomerID string `json:"customerId"`

	// +kubebuilder:validation:Optional
	Description string `json:"description"`
}

// AppComponentStatus defines the observed state of AppComponent
// +k8s:openapi-gen=true
type AppComponentStatus struct {
	// INSERT ADDITIONAL STATUS FIELD - define observed state of cluster
	// Important: Run "operator-sdk generate k8s" to regenerate code after modifying this file
	// Add custom validation using kubebuilder tags: https://book-v1.book.kubebuilder.io/beyond_basics/generating_crd.html
}

// +k8s:deepcopy-gen:interfaces=k8s.io/apimachinery/pkg/runtime.Object

// AppComponent is the Schema for the appcomponents API
// +kubebuilder:subresource:status
// +kubebuilder:resource:path=appcomponents,scope=Namespaced
type AppComponent struct {
	metav1.TypeMeta   `json:",inline"`
	metav1.ObjectMeta `json:"metadata,omitempty"`

	Spec   AppComponentSpec   `json:"spec,omitempty"`
	Status AppComponentStatus `json:"status,omitempty"`
}

// +k8s:deepcopy-gen:interfaces=k8s.io/apimachinery/pkg/runtime.Object

// AppComponentList contains a list of AppComponent
type AppComponentList struct {
	metav1.TypeMeta `json:",inline"`
	metav1.ListMeta `json:"metadata,omitempty"`
	Items           []AppComponent `json:"items"`
}

func init() {
	SchemeBuilder.Register(&AppComponent{}, &AppComponentList{})
}
