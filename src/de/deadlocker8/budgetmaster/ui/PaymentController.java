package de.deadlocker8.budgetmaster.ui;

import java.io.IOException;
import java.time.LocalDate;
import java.util.Locale;
import java.util.ResourceBundle;

import de.deadlocker8.budgetmaster.logic.Category;
import de.deadlocker8.budgetmaster.logic.CategoryBudget;
import de.deadlocker8.budgetmaster.logic.Payment;
import de.deadlocker8.budgetmaster.logic.RepeatingType;
import de.deadlocker8.budgetmaster.ui.cells.CategoryBudgetCell;
import de.deadlocker8.budgetmaster.ui.cells.PaymentCell;
import javafx.application.Platform;
import javafx.beans.value.ChangeListener;
import javafx.beans.value.ObservableValue;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.scene.control.Alert;
import javafx.scene.control.Alert.AlertType;
import javafx.scene.control.Label;
import javafx.scene.control.ListCell;
import javafx.scene.control.ListView;
import javafx.scene.image.Image;
import javafx.scene.paint.Color;
import javafx.stage.Modality;
import javafx.stage.Stage;
import javafx.util.Callback;
import logger.LogLevel;
import logger.Logger;

public class PaymentController
{	
	@FXML private Label labelIncomes;
	@FXML private Label labelPayments;
	@FXML private ListView<Payment> listView;

	private Controller controller;
	private Image icon = new Image("de/deadlocker8/budgetmaster/resources/icon.png");
	private final ResourceBundle bundle = ResourceBundle.getBundle("de/deadlocker8/budgetmaster/main/", Locale.GERMANY);

	public void init(Controller controller)
	{
		this.controller = controller;

		listView.setFixedCellSize(60.0);
		listView.setCellFactory(new Callback<ListView<Payment>, ListCell<Payment>>()
		{
			@Override
			public ListCell<Payment> call(ListView<Payment> param)
			{
				return new PaymentCell();
			}
		});

		listView.getSelectionModel().selectedIndexProperty().addListener(new ChangeListener<Number>()
		{
			@Override
			public void changed(ObservableValue<? extends Number> observable, Number oldValue, Number newValue)
			{
				Platform.runLater(new Runnable()
				{
					public void run()
					{
						listView.getSelectionModel().select(-1);
					}
				});
			}
		});

		// DEBUG
		listView.getItems().add(new Payment(false, 50.23, LocalDate.now(), new Category("Auto", Color.GREEN), "Tanken", RepeatingType.NONE, 0));
		listView.getItems().add(new Payment(true, 50.23, LocalDate.now(), new Category("Einkommen", Color.GREEN), "Einkommen", RepeatingType.NONE, 0));	
	}

	public void newIncome()
	{
		try
		{
			FXMLLoader fxmlLoader = new FXMLLoader(getClass().getResource("/de/deadlocker8/budgetmaster/ui/NewIncomeGUI.fxml"));
			Parent root = (Parent)fxmlLoader.load();
			Stage newStage = new Stage();
			newStage.initOwner((controller.getStage()));
			newStage.initModality(Modality.APPLICATION_MODAL);
			newStage.setTitle("Neue Einnahme");
			newStage.setScene(new Scene(root));
			newStage.getIcons().add(icon);
			newStage.setResizable(false);
			NewIncomeController newController = fxmlLoader.getController();
			newController.init(newStage, controller, this);
			newStage.show();
		}
		catch(IOException e)
		{
			Logger.log(LogLevel.ERROR, Logger.exceptionToString(e));
		}
	}

	public void newPayment()
	{
		try
		{
			FXMLLoader fxmlLoader = new FXMLLoader(getClass().getResource("/de/deadlocker8/budgetmaster/ui/NewPaymentGUI.fxml"));
			Parent root = (Parent)fxmlLoader.load();
			Stage newStage = new Stage();
			newStage.initOwner(controller.getStage());
			newStage.initModality(Modality.APPLICATION_MODAL);
			newStage.setTitle("Neuer Ausgabe");
			newStage.setScene(new Scene(root));
			newStage.getIcons().add(icon);
			newStage.setResizable(false);
			NewPaymentController newController = fxmlLoader.getController();
			newController.init(newStage, controller, this);
			newStage.show();
		}
		catch(IOException e)
		{
			Logger.log(LogLevel.ERROR, Logger.exceptionToString(e));
		}
	}

	public void about()
	{
		Alert alert = new Alert(AlertType.INFORMATION);
		alert.setTitle("�ber " + bundle.getString("app.name"));
		alert.setHeaderText(bundle.getString("app.name"));
		alert.setContentText("Version:     " + bundle.getString("version.name") + "\r\nDatum:      " + bundle.getString("version.date") + "\r\nAutor:        Robert Goldmann\r\n");
		Stage dialogStage = (Stage)alert.getDialogPane().getScene().getWindow();
		dialogStage.getIcons().add(icon);
		dialogStage.centerOnScreen();
		alert.showAndWait();
	}
}