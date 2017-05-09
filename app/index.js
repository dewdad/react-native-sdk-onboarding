import React, { Component } from 'react';
import {
  AppRegistry,
  StyleSheet,
  Text,
  TextInput,
  Button,
  View
} from 'react-native';


export default class HyperTrackOnboarding extends Component {
  constructor(props) {
    super(props);
    this.state = { text: 'Useless placeholder', showLogin: true };
  }

  showLoginScreen() {
    return (
      <View style={styles.container}>
        <TextInput
          style={{height: 40, borderColor: 'gray', borderWidth: 1}}
          onChangeText={(text) => this.setState({text})}
          value={this.state.text}
        />

        <TextInput
          style={{height: 40, borderColor: 'gray', borderWidth: 1}}
          onChangeText={(text) => this.setState({text})}
          value={this.state.text}
        />

        <Button
          onPress={this.showLogoutScreen.bind(this)}
          title='Log in'
          accessibilityLabel='Log in'
        />
      </View>
    );
  }

  showLogoutScreen() {
    return (
      <View style={styles.container}>
        <Button
          onPress={this.showLogoutScreen.bind(this)}
          title='Log out'
          accessibilityLabel='Log out'
        />
      </View>
    );
  }

  render() {
    let view = this.state.showLogin ? this.showLoginScreen() : this.showLogoutScreen();
    return (
      view
    );
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#F5FCFF',
  },
  welcome: {
    fontSize: 20,
    textAlign: 'center',
    margin: 10,
  },
  instructions: {
    textAlign: 'center',
    color: '#333333',
    marginBottom: 5,
  },
});
