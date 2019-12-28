package controller

import (
	"github.com/totr/application-component-operator/pkg/controller/appcomponent"
)

func init() {
	// AddToManagerFuncs is a list of functions to create controllers and add them to a manager.
	AddToManagerFuncs = append(AddToManagerFuncs, appcomponent.Add)
}
